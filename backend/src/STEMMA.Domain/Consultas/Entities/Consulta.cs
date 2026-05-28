using STEMMA.Domain.Cadastro.Entities;
using STEMMA.Domain.Consultas.Enums;

namespace STEMMA.Domain.Consultas.Entities;

public class Consulta
{
    public Guid Id { get; private set; }

    public Guid PetId { get; private set; }

    public Guid VeterinarioId { get; private set; }

    public Veterinario Veterinario { get; private set; }

    public DateTime DataConsulta { get; private set; }

    public StatusConsulta Status { get; private set; }

    protected Consulta() { }

    public Consulta(Guid petId, Guid veterinarioId, DateTime dataConsulta)
    {
        Validar(petId, veterinarioId, dataConsulta);

        Id = Guid.NewGuid();
        PetId = petId;
        VeterinarioId = veterinarioId;
        DataConsulta = dataConsulta;
        Status = StatusConsulta.Agendada;
    }

    public void Iniciar()
    {
        if (Status != StatusConsulta.Agendada)
            throw new Exception("A consulta não pode ser iniciada.");

        Status = StatusConsulta.EmAndamento;
    }

    public void Encerrar()
    {
        if (Status != StatusConsulta.EmAndamento)
            throw new Exception("A consulta não está em andamento.");

        Status = StatusConsulta.Encerrada;
    }

    public void Cancelar()
    {
        if (Status == StatusConsulta.Encerrada)
            throw new Exception("Consulta já encerrada.");

        Status = StatusConsulta.Cancelada;
    }

    private void Validar(Guid petId, Guid veterinarioId, DateTime dataConsulta)
    {
        if (petId == Guid.Empty)
            throw new Exception("Pet inválido.");

        if (veterinarioId == Guid.Empty)
            throw new Exception("Veterinário inválido.");

        if (dataConsulta <= DateTime.UtcNow)
            throw new Exception("Não é permitido agendar consultas no passado.");
    }
}
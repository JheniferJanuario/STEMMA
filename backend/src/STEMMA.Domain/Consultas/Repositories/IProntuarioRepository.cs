using STEMMA.Domain.Consultas.Entities;

namespace STEMMA.Domain.Consultas.Repositories;
public interface IProntuarioRepository
{
    Task AdicionarAsync(Prontuario prontuario);

    Task AtualizarAsync(Prontuario prontuario);

    Task<Prontuario?> ObterPorIdAsync(Guid id);

    Task<Prontuario?> ObterPorConsultaIdAsync(Guid consultaId);

    Task<List<Prontuario>> ListarAsync();
    Task<List<Prontuario>> ObterPorPetIdAsync(Guid petId);
}
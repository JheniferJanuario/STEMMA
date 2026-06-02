using STEMMA.Domain.Consultas.Entities;
using STEMMA.Domain.Consultas.Repositories;

namespace STEMMA.Infrastructure.Persistence.Repositories;


public class ProntuarioRepository : IProntuarioRepository
{
    public Task AdicionarAsync(Prontuario prontuario)
    {
        throw new NotImplementedException();
    }

    public Task AtualizarAsync(Prontuario prontuario)
    {
        throw new NotImplementedException();
    }

    public Task<List<Prontuario>> ListarAsync()
    {
        throw new NotImplementedException();
    }

    public Task<Prontuario?> ObterPorConsultaIdAsync(Guid consultaId)
    {
        throw new NotImplementedException();
    }

    public Task<Prontuario?> ObterPorIdAsync(Guid id)
    {
        throw new NotImplementedException();
    }
}